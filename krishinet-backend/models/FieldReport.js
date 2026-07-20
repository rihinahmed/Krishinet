const mongoose = require('mongoose');

const fieldReportSchema = new mongoose.Schema(
    {
        region: { type: String, required: true },
        description: { type: String, required: true },
        healthIndex: { type: Number, min: 0, max: 1, required: true },
        ndviScore: { type: Number, min: 0, max: 1, default: 0.75 },
        soilMoisture: { type: Number, default: 60 }, // percentage
        droneStatus: { type: String, default: 'Active' },
        isWarning: { type: Boolean, default: false },
        imageUrl: { type: String, default: '' },
        createdBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
    },
    { timestamps: true }
);

module.exports = mongoose.model('FieldReport', fieldReportSchema);
