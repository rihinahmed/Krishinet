const jwt = require('jsonwebtoken');
const User = require('../models/User');

// Generate tokens
const generateAccessToken = (id) =>
    jwt.sign({ id }, process.env.JWT_SECRET, { expiresIn: process.env.JWT_EXPIRE });

const generateRefreshToken = (id) =>
    jwt.sign({ id }, process.env.JWT_REFRESH_SECRET, {
        expiresIn: process.env.JWT_REFRESH_EXPIRE,
    });

// @route  POST /api/auth/register
// @access Public
const register = async (req, res) => {
    try {
        const { name, email, phone, password, role } = req.body;

        if (!name || !email || !password || !role) {
            return res.status(400).json({ message: 'Please provide name, email, password, and role' });
        }

        const validRoles = ['farmer', 'buyer', 'expert', 'govt'];
        if (!validRoles.includes(role)) {
            return res.status(400).json({ message: `Invalid role. Must be one of: ${validRoles.join(', ')}` });
        }

        const existingUser = await User.findOne({ email });
        if (existingUser) {
            return res.status(409).json({ message: 'Email already registered' });
        }

        const user = await User.create({
            name,
            email,
            phone: phone || '',
            passwordHash: password, // Will be hashed by pre-save hook
            role,
        });

        const accessToken = generateAccessToken(user._id);
        const refreshToken = generateRefreshToken(user._id);

        user.refreshToken = refreshToken;
        await user.save({ validateBeforeSave: false });

        res.status(201).json({
            message: 'Registration successful',
            accessToken,
            refreshToken,
            user: {
                id: user._id,
                name: user.name,
                email: user.email,
                role: user.role,
                phone: user.phone,
            },
        });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// @route  POST /api/auth/login
// @access Public
const login = async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({ message: 'Please provide email and password' });
        }

        const user = await User.findOne({ email });
        if (!user || !(await user.matchPassword(password))) {
            return res.status(401).json({ message: 'Invalid email or password' });
        }

        if (!user.isActive) {
            return res.status(403).json({ message: 'Account is disabled. Please contact support.' });
        }

        const accessToken = generateAccessToken(user._id);
        const refreshToken = generateRefreshToken(user._id);

        user.refreshToken = refreshToken;
        await user.save({ validateBeforeSave: false });

        res.json({
            message: 'Login successful',
            accessToken,
            refreshToken,
            user: {
                id: user._id,
                name: user.name,
                email: user.email,
                role: user.role,
                phone: user.phone,
                avatarUrl: user.avatarUrl,
            },
        });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// @route  POST /api/auth/refresh
// @access Public (uses refresh token)
const refreshToken = async (req, res) => {
    const { refreshToken: token } = req.body;
    if (!token) return res.status(401).json({ message: 'No refresh token provided' });

    try {
        const decoded = jwt.verify(token, process.env.JWT_REFRESH_SECRET);
        const user = await User.findById(decoded.id);
        if (!user || user.refreshToken !== token) {
            return res.status(403).json({ message: 'Invalid refresh token' });
        }

        const newAccessToken = generateAccessToken(user._id);
        const newRefreshToken = generateRefreshToken(user._id);

        user.refreshToken = newRefreshToken;
        await user.save({ validateBeforeSave: false });

        res.json({ accessToken: newAccessToken, refreshToken: newRefreshToken });
    } catch (error) {
        res.status(403).json({ message: 'Token expired or invalid' });
    }
};

// @route  POST /api/auth/logout
// @access Private
const logout = async (req, res) => {
    try {
        req.user.refreshToken = null;
        await req.user.save({ validateBeforeSave: false });
        res.json({ message: 'Logged out successfully' });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// @route  GET /api/auth/me
// @access Private
const getMe = async (req, res) => {
    res.json({
        id: req.user._id,
        name: req.user.name,
        email: req.user.email,
        role: req.user.role,
        phone: req.user.phone,
        avatarUrl: req.user.avatarUrl,
    });
};

module.exports = { register, login, refreshToken, logout, getMe };
