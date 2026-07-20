const Listing = require('../models/Listing');
const User = require('../models/User');

// @route  GET /api/farmer/profile
const getProfile = async (req, res) => {
    try {
        const farmer = await User.findById(req.user._id).select('-passwordHash -refreshToken');
        res.json(farmer);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// @route  GET /api/farmer/listings
const getListings = async (req, res) => {
    try {
        const listings = await Listing.find({ farmer: req.user._id }).sort({ createdAt: -1 });
        res.json(listings);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// @route  POST /api/farmer/listings
const createListing = async (req, res) => {
    try {
        const { cropName, quantity, price, location, unit } = req.body;
        if (!cropName || !quantity || !price) {
            return res.status(400).json({ message: 'cropName, quantity, and price are required' });
        }
        const listing = await Listing.create({
            farmer: req.user._id,
            cropName,
            quantity,
            price,
            location: location || 'Local Mandi',
            unit: unit || 'kg',
        });
        res.status(201).json(listing);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// @route  DELETE /api/farmer/listings/:id
const deleteListing = async (req, res) => {
    try {
        const listing = await Listing.findOne({ _id: req.params.id, farmer: req.user._id });
        if (!listing) return res.status(404).json({ message: 'Listing not found' });
        await listing.deleteOne();
        res.json({ message: 'Listing removed' });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

module.exports = { getProfile, getListings, createListing, deleteListing };
