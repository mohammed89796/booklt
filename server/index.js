const express=require('express');
const app=express();
const mongoose=require('mongoose');
const config=require('config');
const{clerkMiddleware,clerkClient,getAuth}=require('@clerk/express');
const provider=require('./routes/providers');
const service=require('./routes/services');
const booking=require('./routes/bookings');



app.use(express.json());
app.use(
  clerkMiddleware({
    publishableKey: config.get('CLERK_PUBLISHABLE_KEY'),
    secretKey: config.get('CLERK_SECRET_KEY'),
  })
);
app.use('/api/providers', provider);
app.use('/api/services', service);
app.use('/api/bookings', booking);
app.get("/api/test", (req, res) => {
  const { userId } = getAuth(req);

  if (!userId) {
    return res.status(401).json({
      message: "Unauthorized",
    });
  }

  res.json({
    message: "Authenticated",
    userId,
  });
});




mongoose.connect('mongodb://localhost/booklt')
  .then(()=>{console.log('connected to mongodb')})
  .catch(err=>{console.error(err)});


app.listen(3000,()=>{
  console.log('listnening on port 3000');
});