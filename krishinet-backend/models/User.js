const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema(
    {
        name: { type: String, required: true, trim: true },
        email: { type: String, required: true, unique: true, lowercase: true },
        phone: { type: String, default: '' },
        passwordHash: { type: String, required: true },
        role: {
            type: String,
            enum: ['farmer', 'buyer', 'expert', 'govt', 'admin'],
            required: true,
        },
        isActive: { type: Boolean, default: true },
        avatarUrl: { type: String, default: '' },
        refreshToken: { type: String, default: null },
    },
    { timestamps: true }
);

// Hash password before saving
userSchema.pre('save', async function (next) {
    if (!this.isModified('passwordHash')) return next();
    this.passwordHash = await bcrypt.hash(this.passwordHash, 12);
    next();
});

// Compare passwords
userSchema.methods.matchPassword = async function (entered) {
    return await bcrypt.compare(entered, this.passwordHash);
};

module.exports = mongoose.model('User', userSchema);
