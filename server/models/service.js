const mongoose=require('mongoose');

const serviceSchema=new mongoose.Schema({
  name:{
    type:String,
    required:true
  },
  price:{
    type:Number,
    required:true,
  },
  provider:{
    type:mongoose.Schema.Types.ObjectId,
    ref:'Provider',
    required:true
  },
  description:{
    type:String,
    required:true
  }
});

const Service=mongoose.model('Service',serviceSchema);



module.exports=Service;