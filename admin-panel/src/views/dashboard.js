import React, { useState } from 'react';
// No need to import custom CSS, just make sure bootstrap is imported in your main file

const AdminDashboard = () => {
  // Sample data - in a real app, this would come from your API
  const [users, setUsers] = useState([
    { id: 1, name: 'Jane Smith', items: 8, trades: 12, rating: 4.7, status: 'active' },
    { id: 2, name: 'John Doe', items: 5, trades: 7, rating: 4.2, status: 'active' },
    { id: 3, name: 'Alice Cooper', items: 12, trades: 15, rating: 4.9, status: 'active' },
    { id: 4, name: 'Bob Johnson', items: 3, trades: 4, rating: 3.8, status: 'warning' },
    { id: 5, name: 'Carlos Rodriguez', items: 9, trades: 6, rating: 4.0, status: 'suspended' }
  ]);

  const [trades, setTrades] = useState([
    { id: 101, user1: 'Jane Smith', user2: 'John Doe', date: '2025-03-05', status: 'completed' },
    { id: 102, user1: 'Alice Cooper', user2: 'Bob Johnson', date: '2025-03-05', status: 'pending' },
    { id: 103, user1: 'John Doe', user2: 'Carlos Rodriguez', date: '2025-03-04', status: 'disputed' },
    { id: 104, user1: 'Jane Smith', user2: 'Alice Cooper', date: '2025-03-03', status: 'completed' }
  ]);

  const [reports, setReports] = useState([
    { id: 201, reportedUser: 'Carlos Rodriguez', reportingUser: 'John Doe', reason: 'Item misrepresentation', date: '2025-03-04', status: 'pending' },
    { id: 202, reportedUser: 'Bob Johnson', reportingUser: 'Alice Cooper', reason: 'No-show at trade', date: '2025-03-02', status: 'resolved' }
  ]);

  const [activeTab, setActiveTab] = useState('dashboard');
  const [searchQuery, setSearchQuery] = useState('');

  // Simple stats for the overview cards
  const stats = {
    totalUsers: users.length,
    activeUsers: users.filter(u => u.status === 'active').length,
    totalTrades: trades.length,
    completedTrades: trades.filter(t => t.status === 'completed').length,
    pendingReports: reports.filter(r => r.status === 'pending').length
  };

  const handleResolveReport = (id) => {
    setReports(reports.map(report => 
      report.id === id ? {...report, status: 'resolved'} : report
    ));
  };

  const handleSuspendUser = (id) => {
    setUsers(users.map(user => 
      user.id === id ? {...user, status: 'suspended'} : user
    ));
  };

  const handleActivateUser = (id) => {
    setUsers(users.map(user => 
      user.id === id ? {...user, status: 'active'} : user
    ));
  };

  return (
    <div className="d-flex flex-column vh-100">
      {/* Header */}
      <header className="bg-primary text-white py-3 shadow">
        <div className="container-fluid">
          <div className="d-flex justify-content-between align-items-center">
            <h1 className="h3 mb-0">Barter App Admin</h1>
            <div className="d-flex align-items-center">
              <div className="me-3">
                <input
                  type="text"
                  placeholder="Search..."
                  className="form-control form-control-sm"
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                />
              </div>
              <div className="d-flex align-items-center">
                <span className="me-2">Admin User</span>
                <div className="rounded-circle bg-primary-subtle text-primary d-flex align-items-center justify-content-center" style={{width: '32px', height: '32px'}}>
                  <span>A</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <div className="d-flex flex-grow-1 overflow-hidden">
        {/* Sidebar */}
        <aside className="bg-dark text-white" style={{width: '250px', overflowY: 'auto'}}>
          <nav className="p-3">
            <div className="list-group list-group-flush">
              <button 
                onClick={() => setActiveTab('dashboard')}
                className={`list-group-item list-group-item-action ${activeTab === 'dashboard' ? 'active' : ''}`}
              >
                Dashboard
              </button>
              <button 
                onClick={() => setActiveTab('users')}
                className={`list-group-item list-group-item-action ${activeTab === 'users' ? 'active' : ''}`}
              >
                Users
              </button>
              <button 
                onClick={() => setActiveTab('trades')}
                className={`list-group-item list-group-item-action ${activeTab === 'trades' ? 'active' : ''}`}
              >
                Trades
              </button>
              <button 
                onClick={() => setActiveTab('reports')}
                className={`list-group-item list-group-item-action ${activeTab === 'reports' ? 'active' : ''}`}
              >
                Reports
              </button>
              <button 
                onClick={() => setActiveTab('settings')}
                className={`list-group-item list-group-item-action ${activeTab === 'settings' ? 'active' : ''}`}
              >
                Settings
              </button>
            </div>
          </nav>
        </aside>

        {/* Content Area */}
        <main className="flex-grow-1 p-4 overflow-auto">
          {activeTab === 'dashboard' && (
            <>
              <h2 className="mb-4">Dashboard Overview</h2>
              
              {/* Stats Cards */}
              <div className="row row-cols-1 row-cols-md-3 g-4 mb-4">
                <div className="col">
                  <div className="card h-100">
                    <div className="card-body">
                      <h5 className="card-title text-muted">Total Users</h5>
                      <div className="d-flex align-items-baseline mt-3">
                        <span className="display-5 fw-bold">{stats.totalUsers}</span>
                        <span className="ms-2 text-success">({stats.activeUsers} active)</span>
                      </div>
                    </div>
                  </div>
                </div>
                
                <div className="col">
                  <div className="card h-100">
                    <div className="card-body">
                      <h5 className="card-title text-muted">Total Trades</h5>
                      <div className="d-flex align-items-baseline mt-3">
                        <span className="display-5 fw-bold">{stats.totalTrades}</span>
                        <span className="ms-2 text-success">({stats.completedTrades} completed)</span>
                      </div>
                    </div>
                  </div>
                </div>
                
                <div className="col">
                  <div className="card h-100">
                    <div className="card-body">
                      <h5 className="card-title text-muted">Pending Reports</h5>
                      <div className="d-flex align-items-baseline mt-3">
                        <span className="display-5 fw-bold">{stats.pendingReports}</span>
                        <span className="ms-2 text-danger">(needs attention)</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              
              {/* Recent Activity */}
              <div className="card mb-4">
                <div className="card-header">
                  <h5 className="mb-0">Recent Activity</h5>
                </div>
                <div className="card-body">
                  <ul className="list-group list-group-flush">
                    <li className="list-group-item">
                      <span className="text-primary">Trade #{trades[0].id}</span> between {trades[0].user1} and {trades[0].user2} was marked as {trades[0].status}.
                    </li>
                    <li className="list-group-item">
                      <span className="text-danger">Report #{reports[0].id}</span>: {reports[0].reportingUser} reported {reports[0].reportedUser} for "{reports[0].reason}".
                    </li>
                    <li className="list-group-item">
                      <span className="text-primary">Trade #{trades[1].id}</span> between {trades[1].user1} and {trades[1].user2} is {trades[1].status}.
                    </li>
                  </ul>
                </div>
              </div>
            </>
          )}

          {activeTab === 'users' && (
            <>
              <h2 className="mb-4">User Management</h2>
              <div className="card">
                <div className="card-body p-0">
                  <div className="table-responsive">
                    <table className="table table-hover mb-0">
                      <thead className="table-light">
                        <tr>
                          <th>Name</th>
                          <th>Items</th>
                          <th>Trades</th>
                          <th>Rating</th>
                          <th>Status</th>
                          <th>Actions</th>
                        </tr>
                      </thead>
                      <tbody>
                        {users.map(user => (
                          <tr key={user.id}>
                            <td>{user.name}</td>
                            <td>{user.items}</td>
                            <td>{user.trades}</td>
                            <td>{user.rating}</td>
                            <td>
                              <span className={`badge ${
                                user.status === 'active' ? 'bg-success' : 
                                user.status === 'warning' ? 'bg-warning' : 
                                'bg-danger'
                              }`}>
                                {user.status}
                              </span>
                            </td>
                            <td>
                              <div className="d-flex gap-2">
                                {user.status !== 'suspended' ? (
                                  <button 
                                    onClick={() => handleSuspendUser(user.id)}
                                    className="btn btn-danger btn-sm"
                                  >
                                    Suspend
                                  </button>
                                ) : (
                                  <button 
                                    onClick={() => handleActivateUser(user.id)}
                                    className="btn btn-success btn-sm"
                                  >
                                    Activate
                                  </button>
                                )}
                                <button className="btn btn-primary btn-sm">
                                  View
                                </button>
                              </div>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </>
          )}

          {activeTab === 'trades' && (
            <>
              <h2 className="mb-4">Trade Management</h2>
              <div className="card">
                <div className="card-body p-0">
                  <div className="table-responsive">
                    <table className="table table-hover mb-0">
                      <thead className="table-light">
                        <tr>
                          <th>ID</th>
                          <th>User 1</th>
                          <th>User 2</th>
                          <th>Date</th>
                          <th>Status</th>
                          <th>Actions</th>
                        </tr>
                      </thead>
                      <tbody>
                        {trades.map(trade => (
                          <tr key={trade.id}>
                            <td>#{trade.id}</td>
                            <td>{trade.user1}</td>
                            <td>{trade.user2}</td>
                            <td>{trade.date}</td>
                            <td>
                              <span className={`badge ${
                                trade.status === 'completed' ? 'bg-success' : 
                                trade.status === 'pending' ? 'bg-warning' : 
                                'bg-danger'
                              }`}>
                                {trade.status}
                              </span>
                            </td>
                            <td>
                              <button className="btn btn-primary btn-sm">
                                Details
                              </button>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </>
          )}

          {activeTab === 'reports' && (
            <>
              <h2 className="mb-4">Reports</h2>
              <div className="card">
                <div className="card-body p-0">
                  <div className="table-responsive">
                    <table className="table table-hover mb-0">
                      <thead className="table-light">
                        <tr>
                          <th>ID</th>
                          <th>Reported User</th>
                          <th>Reporting User</th>
                          <th>Reason</th>
                          <th>Date</th>
                          <th>Status</th>
                          <th>Actions</th>
                        </tr>
                      </thead>
                      <tbody>
                        {reports.map(report => (
                          <tr key={report.id}>
                            <td>#{report.id}</td>
                            <td>{report.reportedUser}</td>
                            <td>{report.reportingUser}</td>
                            <td>{report.reason}</td>
                            <td>{report.date}</td>
                            <td>
                              <span className={`badge ${
                                report.status === 'resolved' ? 'bg-success' : 
                                'bg-warning'
                              }`}>
                                {report.status}
                              </span>
                            </td>
                            <td>
                              <div className="d-flex gap-2">
                                {report.status === 'pending' && (
                                  <button 
                                    onClick={() => handleResolveReport(report.id)}
                                    className="btn btn-success btn-sm"
                                  >
                                    Resolve
                                  </button>
                                )}
                                <button className="btn btn-primary btn-sm">
                                  Details
                                </button>
                              </div>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </>
          )}

          {activeTab === 'settings' && (
            <>
              <h2 className="mb-4">Admin Settings</h2>
              <div className="card">
                <div className="card-body">
                  <div className="mb-4">
                    <h5 className="mb-3">Application Settings</h5>
                    <div className="mb-3">
                      <label className="form-label">
                        Automatic Report Notifications
                      </label>
                      <div>
                        <div className="form-check form-check-inline">
                          <input className="form-check-input" type="radio" name="notifications" id="notifyAll" value="all" defaultChecked />
                          <label className="form-check-label" htmlFor="notifyAll">All Reports</label>
                        </div>
                        <div className="form-check form-check-inline">
                          <input className="form-check-input" type="radio" name="notifications" id="notifyCritical" value="critical" />
                          <label className="form-check-label" htmlFor="notifyCritical">Critical Only</label>
                        </div>
                      </div>
                    </div>
                    
                    <div className="mb-3">
                      <label className="form-label">
                        User Verification Requirements
                      </label>
                      <select className="form-select">
                        <option>Email Verification Only</option>
                        <option>Email + Phone Verification</option>
                        <option>Email + ID Verification</option>
                      </select>
                    </div>
                    
                    <div className="mb-3">
                      <label className="form-label">
                        Trade Dispute Window (days)
                      </label>
                      <input 
                        type="number" 
                        className="form-control"
                        defaultValue={7}
                        min={1}
                        max={30}
                      />
                    </div>
                  </div>
                  
                  <h5 className="mb-3">Admin Account</h5>
                  <div className="mb-3">
                    <label className="form-label">
                      Email
                    </label>
                    <input 
                      type="email" 
                      className="form-control"
                      defaultValue="admin@barterapp.com"
                    />
                  </div>
                  
                  <div className="mb-3">
                    <label className="form-label">
                      Password
                    </label>
                    <button className="btn btn-secondary">
                      Change Password
                    </button>
                  </div>
                  
                  <div className="mb-3">
                    <label className="form-label">
                      Two-Factor Authentication
                    </label>
                    <div>
                      <button className="btn btn-success">
                        Enable 2FA
                      </button>
                    </div>
                  </div>
                  
                  <div className="mt-4">
                    <button className="btn btn-primary">
                      Save Settings
                    </button>
                  </div>
                </div>
              </div>
            </>
          )}
        </main>
      </div>
    </div>
  );
};

export default AdminDashboard;