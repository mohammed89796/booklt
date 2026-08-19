const express=require('express');
const Provider = require('../models/provider');
const router=express.Router();
const Service = require('../models/service');

router.get('/',async(req,res)=>{
  const provider=await Provider.find();
  res.send(provider);
})

router.get('/:providerId/services', async (req, res) => {
  try {
    const services = await Service.find({
      provider: req.params.providerId
    });

    res.json(services);
  } catch (error) {
    res.status(500).json({
      message: error.message
    });
  }
});

module.exports=router;