import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";
import { getAuth } from "firebase/auth";

const firebaseConfig = {
    apiKey: "AIzaSyAHxzDARu1x25Yix1aVuBYcpjyidg4fp3Q",
    authDomain: "barza-mobile-app.firebaseapp.com",
    projectId: "barza-mobile-app",
    storageBucket: "barza-mobile-app.firebasestorage.app",
    messagingSenderId: "688435936708",
    appId: "1:688435936708:web:46172d5a2d44468bd03891",
    measurementId: "G-CVZYZEY745"
};

const app = initializeApp(firebaseConfig);
export const db = getFirestore(app);
export const auth = getAuth(app);
export default app;
