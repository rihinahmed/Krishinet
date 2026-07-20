const User = require('../models/User');
const Listing = require('../models/Listing');
const Order = require('../models/Order');
const Subsidy = require('../models/Subsidy');

// @route  GET /api/admin/stats
const getStats = async (req, res) => {
    try {
        const [totalFarmers, totalBuyers, totalExperts, totalListings, totalOrders, pendingSubsidies] =
            await Promise.all([
                User.countDocuments({ role: 'farmer' }),
                User.countDocuments({ role: 'buyer' }),
                User.countDocuments({ role: 'expert' }),
                Listing.countDocuments(),
                Order.countDocuments(),
                Subsidy.countDocuments({ status: 'Pending' }),
            ]);

        res.json({
            totalFarmers,
            totalBuyers,
            totalExperts,
            totalListings,
            totalOrders,
            pendingSubsidies,
            grossVolumeLabel: '৳24.8M',   // Placeholder; compute from orders for real value
            uptimeScore: '99.98%',
        });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// @route  GET /api/admin/users
const getUsers = async (req, res) => {
    try {
        const { role, page = 1, limit = 20 } = req.query;
        const filter = role ? { role } : {};
        const users = await User.find(filter)
            .select('-passwordHash -refreshToken')
            .sort({ createdAt: -1 })
            .skip((page - 1) * limit)
            .limit(Number(limit));
        const total = await User.countDocuments(filter);
        res.json({ users, total, page: Number(page) });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// @route  PATCH /api/admin/users/:id/toggle
const toggleUserStatus = async (req, res) => {
    try {
        const user = await User.findById(req.params.id);
        if (!user) return res.status(404).json({ message: 'User not found' });
        user.isActive = !user.isActive;
        await user.save({ validateBeforeSave: false });
        res.json({ id: user._id, isActive: user.isActive });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// @route  DELETE /api/admin/users/:id
const deleteUser = async (req, res) => {
    try {
        const user = await User.findByIdAndDelete(req.params.id);
        if (!user) return res.status(404).json({ message: 'User not found' });
        res.json({ message: 'User deleted' });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

module.exports = { getStats, getUsers, toggleUserStatus, deleteUser };
