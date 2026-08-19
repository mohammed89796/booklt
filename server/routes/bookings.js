const express = require('express');
const Service = require('../models/service');
const Booking = require('../models/booking');
const { User } = require('../models/user');
const { getAuth } = require('@clerk/express');

const router = express.Router();

router.post('/', async (req, res) => {
  try {
    const { userId } = getAuth(req);

    if (!userId) {
      return res.status(401).json({
        message: 'Unauthorized'
      });
    }

    const { provider, service, date } = req.body;

    if (!provider || !service || !date) {
      return res.status(400).json({
        message: 'provider, service and date are required'
      });
    }

    let user = await User.findOne({
      clerkUserId: userId
    });

    if (!user) {
      user = new User({
        clerkUserId: userId,
        role: 'customer'
      });

      await user.save();
    }

    const serviceExists = await Service.findById(service);

    if (!serviceExists) {
      return res.status(404).json({
        message: 'Service not found'
      });
    }

    if (serviceExists.provider.toString() !== provider) {
      return res.status(400).json({
        message: 'Service does not belong to this provider'
      });
    }

    const bookingDate = new Date(date);

    if (isNaN(bookingDate.getTime())) {
      return res.status(400).json({
        message: 'Invalid date'
      });
    }

    const existingBooking = await Booking.findOne({
      provider,
      date: bookingDate,
      status: {
        $in: ['pending', 'confirmed']
      }
    });

    if (existingBooking) {
      return res.status(409).json({
        message: 'This time slot is already booked'
      });
    }

    const booking = new Booking({
      user: user._id,
      provider,
      service,
      date: bookingDate,
      status: 'pending'
    });

    await booking.save();

    res.status(201).json({
      message: 'Booking created successfully',
      booking
    });

  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: 'Something went wrong',
      error: error.message
    });
  }
});

module.exports = router;