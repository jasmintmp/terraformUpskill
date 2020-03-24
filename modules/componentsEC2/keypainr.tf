
# ---------- Key Pair ----------
# Set up in AWS your public key to allow putty access 
# ------------------------------
resource "aws_key_pair" "akrawiec_public_key" {
  key_name   = "AWS_EC2_public"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAmaKu47XByOz8jyRyCv0ags/XGMu5YDacJah0kf3TZniSQ+AzFJ4MtBDYPaxKNgE29dbZNu2skP66H33VfLwLQZtoWb3Wo7Y24orrrk1k4PrE3JL6p5jinYCXBHJscWscnoTiYzEEV0LzxfsfBsn2VTXPcI2aJSj1PHvph7TQNwhmQ8VhG30Ml0mx1kU21ti/Iazuc93l3jlyQUlt+VQGKYZ0ItEeiS6IMwNewCCKdZlSgBVa3LjRvN6tRZJ+6DziRACoKuVnd8C4gGtXzr2/hurqpCJI3NAeSUI9vrC1aD9VxsdsDEtqzey2Y4HdOMuW7HtgDyHjmttY+ydOivz7hQ== rsa-key-20200318"
}