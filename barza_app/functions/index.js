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
        message: `You have a request to exchange item ID: ${
          newDocument.requestedItemId}.`,
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
