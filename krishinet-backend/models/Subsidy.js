const mongoose = require('mongoose');

const subsidySchema = new mongoose.Schema(
    {
        issuedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
        farmerName: { type: String, required: true },
        farmerId: { type: String, default: '' },
        cropType: { type: String, required: true },
        region: { type: String, required: true },
        amountRequested: { type: String, required: true },
        status: {
            type: String,
            enum: ['Pending', 'Approved', 'Rejected'],
            default: 'Pending',
        },
        priority: {
            type: String,
            enum: ['High', 'Medium', 'Low'],
            default: 'Medium',
        },
        notes: { type: String, default: '' },
        reviewedAt: { type: Date },
    },
    { timestamps: true }
);

module.exports = mongoose.model('Subsidy', subsidySchema);
