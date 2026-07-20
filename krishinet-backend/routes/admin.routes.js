const express = require('express');
const router = express.Router();
const { getStats, getUsers, toggleUserStatus, deleteUser } = require('../controllers/admin.controller');
const { protect, authorize } = require('../middleware/authMiddleware');

router.use(protect, authorize('admin'));

router.get('/stats', getStats);
router.get('/users', getUsers);
router.patch('/users/:id/toggle', toggleUserStatus);
router.delete('/users/:id', deleteUser);

module.exports = router;
