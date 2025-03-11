import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import { getFirestore, doc, getDoc, collection, addDoc, updateDoc } from 'firebase/firestore';

// Star Rating Component
const StarRating = ({ rating, setRating, size = "lg" }) => {
  const [hover, setHover] = useState(0);
  
  const sizeClass = size === "lg" ? "text-3xl" : "text-xl";
  
  return (
    <div className="flex">
      {[...Array(5)].map((star, index) => {
        const ratingValue = index + 1;
        
        return (
          <button
            type="button"
            key={index}
            className={`${sizeClass} bg-transparent border-none outline-none cursor-pointer ${
              ratingValue <= (hover || rating) ? "text-yellow-400" : "text-gray-300"
            } mr-1`}
            onClick={() => setRating(ratingValue)}
            onMouseEnter={() => setHover(ratingValue)}
            onMouseLeave={() => setHover(0)}
          >
            <span>★</span>
          </button>
        );
      })}
    </div>
  );
};

const ItemDetailPage = () => {
  const { itemId } = useParams();
  const [item, setItem] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [rating, setRating] = useState(0);
  const [comment, setComment] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const [success, setSuccess] = useState(false);

  // Fetch item details on component mount
  useEffect(() => {
    const fetchItemDetails = async () => {
      try {
        setLoading(true);
        const db = getFirestore();
        const itemRef = doc(db, 'barter_items', itemId);
        const itemDoc = await getDoc(itemRef);
        
        if (itemDoc.exists()) {
          setItem({
            id: itemDoc.id,
            ...itemDoc.data(),
            createdAt: itemDoc.data().createdAt ? itemDoc.data().createdAt.toDate() : null
          });
        } else {
          setError("Item not found");
        }
      } catch (err) {
        console.error("Error fetching item details:", err);
        setError("Failed to load item details");
      } finally {
        setLoading(false);
      }
    };

    fetchItemDetails();
  }, [itemId]);

  // Handle item confirmation
  const handleConfirmItem = async () => {
    if (rating === 0) {
      alert("Please rate the item before confirming");
      return;
    }

    try {
      setSubmitting(true);
      const db = getFirestore();
      
      // Add to confirmed_items collection
      await addDoc(collection(db, 'confirmed_items'), {
        itemId: item.id,
        itemName: item.itemName,
        description: item.description,
        userId: item.userId,
        rating: rating,
        comment: comment,
        confirmedAt: new Date(),
        category: item.category,
        condition: item.condition,
        images: item.images
      });
      
      // Update original item status if needed
      const itemRef = doc(db, 'barter_items', item.id);
      await updateDoc(itemRef, { 
        status: 'confirmed',
        rating: rating 
      });
      
      setSuccess(true);
    } catch (err) {
      console.error("Error confirming item:", err);
      alert("Failed to confirm item. Please try again.");
    } finally {
      setSubmitting(false);
    }
  };

  if (loading) return <div className="container mt-5"><div className="spinner-border" role="status"></div></div>;
  if (error) return <div className="container mt-5 alert alert-danger">{error}</div>;
  if (!item) return <div className="container mt-5 alert alert-warning">Item not found</div>;

  if (success) {
    return (
      <div className="container mt-5">
        <div className="alert alert-success">
          <h4>Item Successfully Confirmed!</h4>
          <p>The item has been rated {rating} stars and added to confirmed items.</p>
          <button 
            className="btn btn-primary mt-3"
            onClick={() => window.history.back()}
          >
            Back to Admin Dashboard
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="container mt-5">
      <div className="row">
        <div className="col-md-6">
        {item.images && item.images.length > 0 && (
  <div id="itemImageCarousel" className="carousel slide" data-bs-ride="carousel">
    <div className="carousel-inner">
      {item.images.map((url, index) => (
        <div key={index} className={`carousel-item ${index === 0 ? 'active' : ''}`}>
          <img 
            src={url} 
            className="d-block w-100" 
            alt={`${item.itemName} - image ${index + 1}`}
            style={{ height: "300px", objectFit: "cover" }} 
          />
        </div>
      ))}
    </div>
    {item.images.length > 1 && (
      <>
        <button className="carousel-control-prev" type="button" data-bs-target="#itemImageCarousel" data-bs-slide="prev">
          <span className="carousel-control-prev-icon" aria-hidden="true"></span>
          <span className="visually-hidden">Previous</span>
        </button>
        <button className="carousel-control-next" type="button" data-bs-target="#itemImageCarousel" data-bs-slide="next">
          <span className="carousel-control-next-icon" aria-hidden="true"></span>
          <span className="visually-hidden">Next</span>
        </button>
      </>
    )}
  </div>
)}
          <div className="card">
            <div className="card-header bg-primary text-white">
              <h3>{item.itemName}</h3>
            </div>
            <div className="card-body">
              <div className="mb-3">
                <strong>Category:</strong> {item.category}
              </div>
              <div className="mb-3">
                <strong>Condition:</strong> {item.condition}
              </div>
              <div className="mb-3">
                <strong>Description:</strong> {item.description || 'No description provided'}
              </div>
              <div className="mb-3">
                <strong>Posted By:</strong> User ID: {item.userId}
              </div>
              <div className="mb-3">
                <strong>Date Added:</strong> {item.createdAt ? item.createdAt.toLocaleDateString() : 'N/A'}
              </div>
              <div className="mb-3">
                <strong>Status:</strong> 
                <span className={`badge ms-2 ${item.status === "active" ? "bg-success" : "bg-danger"}`}>
                  {item.status}
                </span>
              </div>
            </div>
          </div>
        </div>
        
        <div className="col-md-6">
          <div className="card">
            <div className="card-header bg-secondary text-white">
              <h3>Rate and Confirm Item</h3>
            </div>
            <div className="card-body">
              <div className="form-group mb-4">
                <label><strong>Rate this item:</strong></label>
                <div className="mt-2">
                  <StarRating rating={rating} setRating={setRating} />
                </div>
                <small className="text-muted">
                  {rating > 0 ? `You've rated this item ${rating} star${rating !== 1 ? 's' : ''}` : 'Click to rate'}
                </small>
              </div>
              
              <div className="form-group mb-4">
                <label htmlFor="comment"><strong>Comment (optional):</strong></label>
                <textarea 
                  id="comment"
                  className="form-control mt-2" 
                  rows="3"
                  value={comment}
                  onChange={(e) => setComment(e.target.value)}
                  placeholder="Add any comments about this item..."
                ></textarea>
              </div>
              
              <button 
                className="btn btn-success btn-lg w-100" 
                onClick={handleConfirmItem}
                disabled={submitting || rating === 0}
              >
                {submitting ? (
                  <>
                    <span className="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
                    Processing...
                  </>
                ) : (
                  "Confirm Item"
                )}
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ItemDetailPage;