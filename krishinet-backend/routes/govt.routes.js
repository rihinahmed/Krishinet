const express = require('express');
const router = express.Router();
const {
    getSubsidies, createSubsidy, reviewSubsidy, getFieldReports, createFieldReport,
} = require('../controllers/govt.controller');
const { protect, authorize } = require('../middleware/authMiddleware');

router.use(protect, authorize('govt', 'admin'));

router.get('/subsidies', getSubsidies);
router.post('/subsidies', createSubsidy);
router.patch('/subsidies/:id', reviewSubsidy);
router.get('/field-reports', getFieldReports);
router.post('/field-reports', createFieldReport);

module.exports = router;
