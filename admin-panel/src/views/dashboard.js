import React, { useState, useEffect } from 'react';
import { getFirestore, collection, getDocs, doc, updateDoc } from 'firebase/firestore';

const AdminDashboard = () => {
  // Replace static users with an empty array initially
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  
  // Rest of your state variables remain the same
  const [trades, setTrades] = useState([
    // your existing trades data
  ]);

  const [reports, setReports] = useState([
    // your existing reports data
  ]);

  const [activeTab, setActiveTab] = useState('dashboard');
  const [searchQuery, setSearchQuery] = useState('');

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

      console.log("User Data:", userSnapshot.docs.map(doc => doc.data()));

      setUsers(userSnapshot.docs.map(doc => ({
        id: doc.id,
        ...doc.data()
      })));
    } catch (error) {
      console.error("Error fetching users:", error);
    } finally {
      setLoading(false);
    }
  };

  fetchUsers();
}, []);


  // Updated stats calculation to handle loading state
  const stats = {
    totalUsers: users.length,
    activeUsers: users.filter(u => u.status === 'active').length,
    totalTrades: trades.length,
    completedTrades: trades.filter(t => t.status === 'completed').length,
    pendingReports: reports.filter(r => r.status === 'pending').length
  };

  // Update the suspend user handler to modify Firebase
  const handleSuspendUser = async (id) => {
    try {
      const db = getFirestore();
      const userRef = doc(db, 'users', id);
      await updateDoc(userRef, { status: 'suspended' });
      
      // Update local state after successful Firebase update
      setUsers(users.map(user => 
        user.id === id ? {...user, status: 'suspended'} : user
      ));
    } catch (error) {
      console.error("Error suspending user:", error);
      alert("Failed to suspend user. Please try again.");
    }
  };

  // Update the activate user handler to modify Firebase
  const handleActivateUser = async (id) => {
    try {
      const db = getFirestore();
      const userRef = doc(db, 'users', id);
      await updateDoc(userRef, { status: 'active' });
      
      // Update local state after successful Firebase update
      setUsers(users.map(user => 
        user.id === id ? {...user, status: 'active'} : user
      ));
    } catch (error) {
      console.error("Error activating user:", error);
      alert("Failed to activate user. Please try again.");
    }
  };

  // Rest of your component remains the same, but you can add a loading state to the users tab
  
  // In the users tab section, add this:
  return (
    <div className="container">
      <h1>Admin Dashboard</h1>
  
      {loading ? (
        <p>Loading users...</p>
      ) : (
        <>
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
                {users.map((user, index) => (
                  <tr key={user.id}>
                    <td>{index + 1}</td>
                    <td>{user.name}</td>
                    <td>{user.email}</td>
                    <td>{user.role}</td>
                    <td>
                      <span className={`badge ${user.status === "active" ? "bg-success" : "bg-danger"}`}>
                        {user.status}
                      </span>
                    </td>
                    <td>
                      <button className="btn btn-warning btn-sm me-2">Edit</button>
                      <button className="btn btn-danger btn-sm">Suspend</button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </>
      )}
    </div>
  );
  
  
};

export default AdminDashboard;
