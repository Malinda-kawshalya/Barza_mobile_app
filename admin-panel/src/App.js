import React, { useEffect } from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import { db } from "./firebase";
import { collection, getDocs } from "firebase/firestore";
import Dashboard from "./views/dashboard"; 
import ItemDetailPage from "./views/itemview";

function App() {
  useEffect(() => {
    const fetchData = async () => {
      try {
        const querySnapshot = await getDocs(collection(db, "testCollection"));
        querySnapshot.forEach((doc) => {
          console.log(doc.id, " => ", doc.data());
        });
        console.log("Firebase is connected! ✅");
      } catch (error) {
        console.error("Error connecting to Firebase ❌", error);
      }
    };

    fetchData();
  }, []);

  return (
    <Router>
      <Routes>
        <Route path="/" element={<Dashboard />} />
        <Route path="/:itemId" element={<ItemDetailPage />} />

      </Routes>
    </Router>
  );
}

export default App;