const mongoose =require('mongoose');
const Joi=require('joi');



const userSchema=new mongoose.Schema({
  clerkUserId:{
    type:String,
    required:true,
    unique:true
  },
  role:{
    type:String,
    enum:['customer','provider','admin'],
    default:'customer'
  }
});

const User=mongoose.model('User',userSchema);

function validateUser(user){
  const schema=Joi.object({
    clerkUserId:Joi.string().required(),
  })
  return schema.validate(user);
}

module.exports.validateUser=validateUser;
module.exports.User=User;