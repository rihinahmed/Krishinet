const Order = require('../models/Order');
const Listing = require('../models/Listing');

// @route  GET /api/buyer/market
// Lists all available crop listings from all farmers
const getMarket = async (req, res) => {
    try {
        const listings = await Listing.find({ isAvailable: true })
            .populate('farmer', 'name phone')
            .sort({ createdAt: -1 });
        res.json(listings);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// @route  GET /api/buyer/orders
const getOrders = async (req, res) => {
    try {
        const orders = await Order.find({ buyer: req.user._id }).sort({ createdAt: -1 });
        res.json(orders);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// @route  POST /api/buyer/orders
const createOrder = async (req, res) => {
    try {
        const { listingId, quantity } = req.body;
        const listing = await Listing.findById(listingId).populate('farmer', 'name');
        if (!listing) return res.status(404).json({ message: 'Listing not found' });

        const order = await Order.create({
            buyer: req.user._id,
            listing: listing._id,
            cropName: listing.cropName,
            quantity: quantity || listing.quantity,
            totalPrice: listing.price,
            farmerName: listing.farmer?.name || 'Unknown',
            trackingId: `KN-${Date.now().toString(36).toUpperCase()}`,
        });
        res.status(201).json(order);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// @route  PATCH /api/buyer/orders/:id
const updateOrderStatus = async (req, res) => {
    try {
        const order = await Order.findOneAndUpdate(
            { _id: req.params.id, buyer: req.user._id },
            { status: req.body.status },
            { new: true }
        );
        if (!order) return res.status(404).json({ message: 'Order not found' });
        res.json(order);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

module.exports = { getMarket, getOrders, createOrder, updateOrderStatus };
