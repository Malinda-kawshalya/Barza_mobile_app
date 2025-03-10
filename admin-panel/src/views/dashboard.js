import React, { useState, useEffect, } from "react";
import { useNavigate } from 'react-router-dom';

import {
  getFirestore,
  collection,
  getDocs,
  doc,
  updateDoc,
} from "firebase/firestore";

const AdminDashboard = () => {
  // State for users and barter items
  const [users, setUsers] = useState([]);
  const [barterItems, setBarterItems] = useState([]);
  const [loading, setLoading] = useState(true);
  const [itemsLoading, setItemsLoading] = useState(true);

  // Rest of your state variables remain the same
  const [trades, setTrades] = useState([
    // your existing trades data
  ]);

  const [reports, setReports] = useState([
    // your existing reports data
  ]);

  const [activeTab, setActiveTab] = useState("dashboard");
  const [searchQuery, setSearchQuery] = useState("");

  // Fetch users from Firebase when component mounts
  useEffect(() => {
    console.log("Fetching users...");

    const fetchUsers = async () => {
      try {
        setLoading(true);
        console.log("Connecting to Firestore...");
        const db = getFirestore();
        const usersCollection = collection(db, "users");
        const userSnapshot = await getDocs(usersCollection);

        console.log(
          "User Data:",
          userSnapshot.docs.map((doc) => doc.data())
        );

        setUsers(
          userSnapshot.docs.map((doc) => ({
            id: doc.id,
            ...doc.data(),
          }))
        );
      } catch (error) {
        console.error("Error fetching users:", error);
      } finally {
        setLoading(false);
      }
    };

    fetchUsers();
  }, []);

  // Fetch barter items from Firebase
  useEffect(() => {
    console.log("Fetching barter items...");

    const fetchBarterItems = async () => {
      try {
        setItemsLoading(true);
        console.log("Connecting to Firestore for barter items...");
        const db = getFirestore();
        const itemsCollection = collection(db, "barter_items");
        const itemsSnapshot = await getDocs(itemsCollection);

        console.log(
          "Barter Items Data:",
          itemsSnapshot.docs.map((doc) => doc.data())
        );

        setBarterItems(
          itemsSnapshot.docs.map((doc) => ({
            id: doc.id,
            ...doc.data(),
            // Convert Timestamp to JS Date for easier display
            createdAt: doc.data().createdAt
              ? doc.data().createdAt.toDate()
              : null,
          }))
        );
      } catch (error) {
        console.error("Error fetching barter items:", error);
      } finally {
        setItemsLoading(false);
      }
    };

    fetchBarterItems();
  }, []);

  // Updated stats calculation to include barter items
  const stats = {
    totalUsers: users.length,
    activeUsers: users.filter((u) => u.status === "active").length,
    totalItems: barterItems.length,
    activeItems: barterItems.filter((item) => item.status === "active").length,
    totalTrades: trades.length,
    completedTrades: trades.filter((t) => t.status === "completed").length,
    pendingReports: reports.filter((r) => r.status === "pending").length,
  };

  // Update the suspend user handler to modify Firebase
  const handleSuspendUser = async (id) => {
    try {
      const db = getFirestore();
      const userRef = doc(db, "users", id);
      await updateDoc(userRef, { status: "suspended" });

      // Update local state after successful Firebase update
      setUsers(
        users.map((user) =>
          user.id === id ? { ...user, status: "suspended" } : user
        )
      );
    } catch (error) {
      console.error("Error suspending user:", error);
      alert("Failed to suspend user. Please try again.");
    }
  };

  // Update the activate user handler to modify Firebase
  const handleActivateUser = async (id) => {
    try {
      const db = getFirestore();
      const userRef = doc(db, "users", id);
      await updateDoc(userRef, { status: "active" });

      // Update local state after successful Firebase update
      setUsers(
        users.map((user) =>
          user.id === id ? { ...user, status: "active" } : user
        )
      );
    } catch (error) {
      console.error("Error activating user:", error);
      alert("Failed to activate user. Please try again.");
    }
  };

  // Handle barter item status update
  const handleUpdateItemStatus = async (id, newStatus) => {
    try {
      const db = getFirestore();
      const itemRef = doc(db, "barter_items", id);
      await updateDoc(itemRef, { status: newStatus });

      // Update local state after successful Firebase update
      setBarterItems(
        barterItems.map((item) =>
          item.id === id ? { ...item, status: newStatus } : item
        )
      );
    } catch (error) {
      console.error(`Error updating item to ${newStatus}:`, error);
      alert(`Failed to update item status. Please try again.`);
    }
  };

  // Render dashboard content
  const renderDashboardContent = () => {
    return (
      <>
        <div className="row mt-4">
          <div className="col-md-3">
            <div className="card bg-primary text-white">
              <div className="card-body">
                <h5 className="card-title">Total Users</h5>
                <h2>{stats.totalUsers}</h2>
              </div>
            </div>
          </div>
          <div className="col-md-3">
            <div className="card bg-success text-white">
              <div className="card-body">
                <h5 className="card-title">Active Items</h5>
                <h2>{stats.activeItems}</h2>
              </div>
            </div>
          </div>
          <div className="col-md-3">
            <div className="card bg-info text-white">
              <div className="card-body">
                <h5 className="card-title">Total Trades</h5>
                <h2>{stats.totalTrades}</h2>
              </div>
            </div>
          </div>
          <div className="col-md-3">
            <div className="card bg-warning">
              <div className="card-body">
                <h5 className="card-title">Pending Reports</h5>
                <h2>{stats.pendingReports}</h2>
              </div>
            </div>
          </div>
        </div>

        <div className="row mt-4">
          <div className="col-md-6">
            <div className="card">
              <div className="card-header">Recent Users</div>
              <div className="card-body">
                {loading ? (
                  <p>Loading users...</p>
                ) : (
                  <table className="table table-sm">
                    <thead>
                      <tr>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Status</th>
                      </tr>
                    </thead>
                    <tbody>
                      {users.slice(0, 5).map((user) => (
                        <tr key={user.id}>
                          <td>{user.name}</td>
                          <td>{user.email}</td>
                          <td>
                            <span
                              className={`badge ${
                                user.status === "active"
                                  ? "bg-success"
                                  : "bg-danger"
                              }`}
                            >
                              {user.status}
                            </span>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                )}
              </div>
            </div>
          </div>
          <div className="col-md-6">
            <div className="card">
              <div className="card-header">Recent Barter Items</div>
              <div className="card-body">
                {itemsLoading ? (
                  <p>Loading items...</p>
                ) : (
                  <table className="table table-sm">
                    <thead>
                      <tr>
                        <th>Item Name</th>
                        <th>Category</th>
                        <th>Status</th>
                      </tr>
                    </thead>
                    <tbody>
                      {barterItems.slice(0, 5).map((item) => (
                        <tr key={item.id}>
                          <td>{item.itemName}</td>
                          <td>{item.category}</td>
                          <td>
                            <span
                              className={`badge ${
                                item.status === "active"
                                  ? "bg-success"
                                  : "bg-danger"
                              }`}
                            >
                              {item.status}
                            </span>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                )}
              </div>
            </div>
          </div>
        </div>
      </>
    );
  };

  // Render users content
  const renderUsersContent = () => {
    return (
      <>
        {loading ? (
          <p>Loading users...</p>
        ) : (
          <>
            <div className="mb-3">
              <input
                type="text"
                className="form-control"
                placeholder="Search users..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
              />
            </div>

            <p>Users Loaded: {users.length}</p>
            <div className="table-responsive">
              <table className="table table-hover">
                <thead className="table-dark">
                  <tr>
                    <th>#</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Status</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {users
                    .filter(
                      (user) =>
                        user.name
                          ?.toLowerCase()
                          .includes(searchQuery.toLowerCase()) ||
                        user.email
                          ?.toLowerCase()
                          .includes(searchQuery.toLowerCase())
                    )
                    .map((user, index) => (
                      <tr key={user.id}>
                        <td>{index + 1}</td>
                        <td>{user.name}</td>
                        <td>{user.email}</td>
                        <td>{user.role || "User"}</td>
                        <td>
                          <span
                            className={`badge ${
                              user.status === "active"
                                ? "bg-success"
                                : "bg-danger"
                            }`}
                          >
                            {user.status}
                          </span>
                        </td>
                        <td>
                          {user.status === "active" ? (
                            <button
                              className="btn btn-danger btn-sm"
                              onClick={() => handleSuspendUser(user.id)}
                            >
                              Suspend
                            </button>
                          ) : (
                            <button
                              className="btn btn-success btn-sm"
                              onClick={() => handleActivateUser(user.id)}
                            >
                              Activate
                            </button>
                          )}
                        </td>
                      </tr>
                    ))}
                </tbody>
              </table>
            </div>
          </>
        )}
      </>
    );
  };
  const navigate = useNavigate();

  // Render items content
  const renderItemsContent = () => {
    return (
      <>
        {itemsLoading ? (
          <p>Loading items...</p>
        ) : (
          <>
            <div className="mb-3">
              <input
                type="text"
                className="form-control"
                placeholder="Search items..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
              />
            </div>

            <p>Items Loaded: {barterItems.length}</p>
            <div className="table-responsive">
              <table className="table table-hover">
                <thead className="table-dark">
                  <tr>
                    <th>#</th>
                    <th>Item Name</th>
                    <th>Category</th>
                    <th>Condition</th>
                    <th>Description</th>
                    <th>Date Added</th>
                    <th>Status</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {barterItems
                    .filter(
                      (item) =>
                        item.itemName
                          ?.toLowerCase()
                          .includes(searchQuery.toLowerCase()) ||
                        item.category
                          ?.toLowerCase()
                          .includes(searchQuery.toLowerCase())
                    )
                    .map((item, index) => (
                      <tr key={item.id}>
                        <td>{index + 1}</td>
                        <td>{item.itemName}</td>
                        <td>{item.category}</td>
                        <td>{item.condition}</td>
                        <td>{item.description}</td>
                        <td>
                          {item.createdAt
                            ? item.createdAt.toLocaleDateString()
                            : "N/A"}
                        </td>
                        <td>
                          <span
                            className={`badge ${
                              item.status === "active"
                                ? "bg-success"
                                : "bg-danger"
                            }`}
                          >
                            {item.status}
                          </span>
                        </td>
                        <td>
                          <div className="btn-group">
                            <button
                              className="btn btn-primary btn-sm me-1"
                              onClick={() => navigate(`/${item.id}`)}
                            >
                              View
                            </button>

                            {item.status === "active" ? (
                              <button
                                className="btn btn-danger btn-sm"
                                onClick={() =>
                                  handleUpdateItemStatus(item.id, "inactive")
                                }
                              >
                                Deactivate
                              </button>
                            ) : (
                              <button
                                className="btn btn-success btn-sm"
                                onClick={() =>
                                  handleUpdateItemStatus(item.id, "active")
                                }
                              >
                                Activate
                              </button>
                            )}
                          </div>
                        </td>
                      </tr>
                    ))}
                </tbody>
              </table>
            </div>
          </>
        )}
      </>
    );
  };

  // Render trades content (placeholder for now)
  const renderTradesContent = () => {
    return (
      <div>
        <h2>Trades Management</h2>
        <p>Trade management functionality coming soon...</p>
      </div>
    );
  };

  // Render reports content (placeholder for now)
  const renderReportsContent = () => {
    return (
      <div>
        <h2>Reports Management</h2>
        <p>Report management functionality coming soon...</p>
      </div>
    );
  };

  // Get the title for the current tab
  const getTabTitle = () => {
    switch (activeTab) {
      case "dashboard":
        return "Admin Dashboard";
      case "users":
        return "User Management";
      case "items":
        return "Barter Items Management";
      case "trades":
        return "Trades Management";
      case "reports":
        return "Reports Management";
      default:
        return "Admin Dashboard";
    }
  };

  // Render tab content based on activeTab
  const renderTabContent = () => {
    switch (activeTab) {
      case "dashboard":
        return renderDashboardContent();
      case "users":
        return renderUsersContent();
      case "items":
        return renderItemsContent();
      case "trades":
        return renderTradesContent();
      case "reports":
        return renderReportsContent();
      default:
        return renderDashboardContent();
    }
  };

  // Main return - always renders navigation and conditionally renders content
  return (
    <div className="container">
      {/* Navigation Tabs - Always rendered */}
      <div className="nav nav-tabs mb-4">
        <div className="nav-item">
          <button
            className={`nav-link ${activeTab === "dashboard" ? "active" : ""}`}
            onClick={() => setActiveTab("dashboard")}
          >
            Dashboard
          </button>
        </div>
        <div className="nav-item">
          <button
            className={`nav-link ${activeTab === "users" ? "active" : ""}`}
            onClick={() => {
              setActiveTab("users");
              setSearchQuery("");
            }}
          >
            Users
          </button>
        </div>
        <div className="nav-item">
          <button
            className={`nav-link ${activeTab === "items" ? "active" : ""}`}
            onClick={() => {
              setActiveTab("items");
              setSearchQuery("");
            }}
          >
            Barter Items
          </button>
        </div>
        <div className="nav-item">
          <button
            className={`nav-link ${activeTab === "trades" ? "active" : ""}`}
            onClick={() => setActiveTab("trades")}
          >
            Trades
          </button>
        </div>
        <div className="nav-item">
          <button
            className={`nav-link ${activeTab === "reports" ? "active" : ""}`}
            onClick={() => setActiveTab("reports")}
          >
            Reports
          </button>
        </div>
      </div>

      {/* Page Title */}
      <h1>{getTabTitle()}</h1>

      {/* Tab Content - Conditionally rendered based on activeTab */}
      {renderTabContent()}
    </div>
  );
};

export default AdminDashboard;
