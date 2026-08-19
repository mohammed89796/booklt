const mongoose=require('mongoose');

const providerSchema=new mongoose.Schema({
  name:{
    type:String,
    required:true
  },
  location:{
    type:String,
    required:true
  },
  image:{
    type:String,
    required:true
  },
 postalCode:{
  type:Number,
  required:true
 }
});

const Provider= mongoose.model('Provider',providerSchema);


module.exports=Provider;