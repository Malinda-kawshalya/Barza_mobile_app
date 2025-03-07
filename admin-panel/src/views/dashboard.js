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
    const fetchUsers = async () => {
      try {
        setLoading(true);
        const db = getFirestore();
        const usersCollection = collection(db, 'users');
        const userSnapshot = await getDocs(usersCollection);
        
        const usersList = userSnapshot.docs.map(doc => {
          const userData = doc.data();
          return {
            id: doc.id,
            name: userData.name || `${userData.firstName || ''} ${userData.lastName || ''}`.trim(),
            items: userData.items?.length || 0,
            trades: userData.trades?.length || 0,
            rating: userData.rating || 0,
            status: userData.status || 'active',
            // Add any other fields you need
          };
        });
        
        setUsers(usersList);
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
      {/* Your existing JSX... */}

      {activeTab === 'users' && (
        <>
          <h2 className="mb-4">User Managements</h2>
          <div className="card">
            <div className="card-body p-0">
              {loading ? (
                <div className="text-center p-4">
                  <div className="spinner-border" role="status">
                    <span className="visually-hidden">Loading...</span>
                  </div>
                  <p className="mt-2">Loading users...</p>
                </div>
              ) : (
                <div className="table-responsive">
                  <table className="table table-hover mb-0">
                    {/* Your existing table header and body */}
                  </table>
                </div>
              )}
            </div>
          </div>
        </>
      )}

      {/* Rest of your JSX... */}
    </div>
  );
};

export default AdminDashboard;
