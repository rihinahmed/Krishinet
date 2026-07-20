const express = require('express');
const router = express.Router();
const { getMarket, getOrders, createOrder, updateOrderStatus } = require('../controllers/buyer.controller');
const { protect, authorize } = require('../middleware/authMiddleware');

// Market is accessible to buyers
router.get('/market', protect, authorize('buyer'), getMarket);
router.get('/orders', protect, authorize('buyer'), getOrders);
router.post('/orders', protect, authorize('buyer'), createOrder);
router.patch('/orders/:id', protect, authorize('buyer'), updateOrderStatus);

module.exports = router;
