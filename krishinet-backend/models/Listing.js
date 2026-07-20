const mongoose = require('mongoose');

const listingSchema = new mongoose.Schema(
    {
        farmer: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
        cropName: { type: String, required: true },
        quantity: { type: String, required: true },
        price: { type: String, required: true },
        location: { type: String, default: 'Local Mandi' },
        unit: { type: String, default: 'kg' },
        isAvailable: { type: Boolean, default: true },
    },
    { timestamps: true }
);

module.exports = mongoose.model('Listing', listingSchema);
