require('dotenv').config();
const express = require('express');
const cors = require('cors');
const connectDB = require('./config/db');

// Route imports
const authRoutes = require('./routes/auth.routes');
const farmerRoutes = require('./routes/farmer.routes');
const buyerRoutes = require('./routes/buyer.routes');
const govtRoutes = require('./routes/govt.routes');
const adminRoutes = require('./routes/admin.routes');

// Connect to MongoDB
connectDB();

const app = express();

// --- Middleware ---
app.use(cors({
    origin: true,
    credentials: true,
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// --- Health check ---
app.get('/', (req, res) => {
    res.json({ status: 'ok', message: 'Krishinet API is running', version: '1.0.0' });
});

// --- API Routes ---
app.use('/api/auth', authRoutes);
app.use('/api/farmer', farmerRoutes);
app.use('/api/buyer', buyerRoutes);
app.use('/api/govt', govtRoutes);
app.use('/api/admin', adminRoutes);

// --- 404 Handler ---
app.use((req, res) => {
    res.status(404).json({ message: `Route ${req.method} ${req.originalUrl} not found` });
});

// --- Global Error Handler ---
app.use((err, req, res, next) => {
    console.error('❌ Unhandled error:', err.stack);
    res.status(500).json({ message: err.message || 'Internal server error' });
});

// --- Start Server ---
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`🚀 Krishinet API server running on http://localhost:${PORT}`);
});
