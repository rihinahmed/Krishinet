const express = require('express');
const router = express.Router();
const { getProfile, getListings, createListing, deleteListing } = require('../controllers/farmer.controller');
const { protect, authorize } = require('../middleware/authMiddleware');

router.use(protect, authorize('farmer'));

router.get('/profile', getProfile);
router.get('/listings', getListings);
router.post('/listings', createListing);
router.delete('/listings/:id', deleteListing);

module.exports = router;
