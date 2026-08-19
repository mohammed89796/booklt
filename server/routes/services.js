const express=require('express');
const router=express.Router();
const Service=require('../models/service');

router.get('/',async(req,res)=>{
  const service=await Service.find().populate('provider');
  res.send(service)
})

module.exports=router;