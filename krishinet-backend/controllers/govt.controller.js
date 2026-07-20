const Subsidy = require('../models/Subsidy');
const FieldReport = require('../models/FieldReport');

// @route  GET /api/govt/subsidies
const getSubsidies = async (req, res) => {
    try {
        const subsidies = await Subsidy.find().sort({ createdAt: -1 });
        res.json(subsidies);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// @route  POST /api/govt/subsidies
const createSubsidy = async (req, res) => {
    try {
        const { farmerName, farmerId, cropType, region, amountRequested, priority } = req.body;
        const subsidy = await Subsidy.create({
            issuedBy: req.user._id,
            farmerName,
            farmerId,
            cropType,
            region,
            amountRequested,
            priority,
        });
        res.status(201).json(subsidy);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// @route  PATCH /api/govt/subsidies/:id
// Body: { status: 'Approved' | 'Rejected', notes: '...' }
const reviewSubsidy = async (req, res) => {
    try {
        const { status, notes } = req.body;
        if (!['Approved', 'Rejected'].includes(status)) {
            return res.status(400).json({ message: "Status must be 'Approved' or 'Rejected'" });
        }
        const subsidy = await Subsidy.findByIdAndUpdate(
            req.params.id,
            { status, notes: notes || '', reviewedAt: new Date() },
            { new: true }
        );
        if (!subsidy) return res.status(404).json({ message: 'Subsidy not found' });
        res.json(subsidy);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// @route  GET /api/govt/field-reports
const getFieldReports = async (req, res) => {
    try {
        const reports = await FieldReport.find().sort({ createdAt: -1 });
        res.json(reports);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// @route  POST /api/govt/field-reports  (seed / create)
const createFieldReport = async (req, res) => {
    try {
        const report = await FieldReport.create({ ...req.body, createdBy: req.user._id });
        res.status(201).json(report);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

module.exports = { getSubsidies, createSubsidy, reviewSubsidy, getFieldReports, createFieldReport };
