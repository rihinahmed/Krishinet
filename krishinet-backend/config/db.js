const mongoose = require('mongoose');
const User = require('../models/User');

const seedDefaultUsers = async () => {
    try {
        const count = await User.countDocuments();
        if (count === 0) {
            console.log('🌱 Database is empty. Seeding default role accounts...');
            const seedUsers = [
                { name: 'Demo Farmer', email: 'farmer@test.com', passwordHash: 'password123', role: 'farmer' },
                { name: 'Demo Buyer', email: 'buyer@test.com', passwordHash: 'password123', role: 'buyer' },
                { name: 'Demo Expert', email: 'expert@test.com', passwordHash: 'password123', role: 'expert' },
                { name: 'Demo Govt', email: 'govt@test.com', passwordHash: 'password123', role: 'govt' },
                { name: 'Demo Admin', email: 'admin@test.com', passwordHash: 'password123', role: 'admin' },
            ];
            await User.create(seedUsers);
            console.log('✅ Seeding complete. Use password "password123" to log in to all accounts.');
        }
    } catch (err) {
        console.error('❌ Failed to seed default users:', err.message);
    }
};

const connectDB = async () => {
    try {
        const conn = await mongoose.connect(process.env.MONGO_URI);
        console.log(`✅ MongoDB Connected: ${conn.connection.host}`);
        await seedDefaultUsers();
    } catch (error) {
        console.error(`❌ MongoDB Connection Error: ${error.message}`);
        process.exit(1);
    }
};

module.exports = connectDB;
