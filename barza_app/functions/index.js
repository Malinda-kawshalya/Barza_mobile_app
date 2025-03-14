const {onDocumentUpdated, onDocumentCreated} = require(
  "firebase-functions/v2/firestore");
const admin = require("firebase-admin");
admin.initializeApp();

exports.onExchangeRequestUpdate = onDocumentUpdated(
  "exchange_requests/{requestId}",
  async (event) => {
    const previousData = event.data.before.data();
    const newData = event.data.after.data();
    const context = event.params;

    if (previousData.status !== newData.status) {
      const requestId = context.requestId;
      const requestingUserId = newData.requestingUserId;
      const itemOwnerId = newData.itemOwnerId;
      const requestedItemId = newData.requestedItemId;
      const status = newData.status;

      let notificationMessage = "";
      let notificationType = "";

      if (status === "accepted") {
        notificationMessage = "Your exchange request was accepted!";
        notificationType = "exchange_accepted";
      } else if (status === "declined") {
        notificationMessage = "Your exchange request was declined.";
        notificationType = "exchange_declined";
      }

      if (notificationMessage) {
        await admin.firestore().collection("notifications").add({
          userId: requestingUserId,
          type: notificationType,
          message: notificationMessage,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
          read: false,
          relatedItemId: requestedItemId,
          senderId: itemOwnerId,
          exchangeRequestId: requestId,
        });
      }
    }
  },
);

exports.onExchangeRequestCreated = onDocumentCreated(
  "exchange_requests/{requestId}",
  async (event) => {
    const newDocument = event.data.data();
    const requestId = event.params.requestId;

    console.log(`New exchange request created with ID: ${requestId}`);
    console.log("New document data:", newDocument);

    if (newDocument.itemOwnerId && newDocument.requestedItemId) {
      await admin.firestore().collection("notifications").add({
        userId: newDocument.itemOwnerId,
        type: "exchange_request",
        message: "You have a request to exchage your item.",
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        read: false,
        relatedItemId: newDocument.requestedItemId,
        senderId: newDocument.requestingUserId,
        exchangeRequestId: requestId,
      });
    } else {
      console.error("itemOwnerId or requestedItemId is missing.");
    }
  },
);

exports.onChatCreated = onDocumentCreated(
  "chats/{chatId}",
  async (event) => {
    const chatData = event.data.data();
    const chatId = event.params.chatId;

    if (!chatData.participants || chatData.participants.length !== 2) {
      console.error(`Invalid chat document structure for chat ${chatId}.`);
      return;
    }

    const messagesSnapshot = await admin
      .firestore()
      .collection("chats")
      .doc(chatId)
      .collection("messages")
      .orderBy("timestamp", "desc")
      .limit(1)
      .get();

    if (messagesSnapshot.empty) {
      console.log(`No messages found in new chat ${chatId}.`);
      return;
    }
    const firstMessage = messagesSnapshot.docs[0].data();
    const senderUserId = firstMessage.senderId;

    const recipientUserId = chatData.participants.find(
      (id) => id !== senderUserId);
    if (!recipientUserId) {
      console.error(`Could not determine recipient for chat ${chatId}.`);
      return;
    }

    let senderName = "Someone";
    try {
      const senderDoc = await admin.firestore().collection(
        "users").doc(senderUserId).get();
      if (senderDoc.exists) {
        const senderData = senderDoc.data();
        senderName = senderData.fullName || senderName;
      }
    } catch (error) {
      console.error(`Error fetching sender data: ${error}`);
    }

    await admin.firestore().collection("notifications").add({
      userId: recipientUserId,
      type: "new_chat",
      message: `${senderName} sent you a message:
       "${firstMessage.message.substring(0, 50)}
       ${firstMessage.message.length > 50 ? "..." : ""}"`,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      read: false,
      senderId: senderUserId,
      chatId: chatId,
    });

    console.log(
      `Notification created for new chat ${chatId} 
      from user ${senderUserId} to ${recipientUserId}`,
    );
  },
);
