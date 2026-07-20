const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema(
    {
        buyer: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
        listing: { type: mongoose.Schema.Types.ObjectId, ref: 'Listing' },
        cropName: { type: String, required: true },
        quantity: { type: String, required: true },
        totalPrice: { type: String, required: true },
        status: {
            type: String,
            enum: ['Pending', 'Confirmed', 'In Transit', 'Delivered', 'Cancelled'],
            default: 'Pending',
        },
        farmerName: { type: String, default: '' },
        estimatedDelivery: { type: String, default: '' },
        trackingId: { type: String, default: '' },
    },
    { timestamps: true }
);

module.exports = mongoose.model('Order', orderSchema);
