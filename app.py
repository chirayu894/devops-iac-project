from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route('/')
def home():
    # Good DevOps practice: Use Environment Variables for configuration
    # This allows us to change the message without touching the code!
    message = os.getenv('WELCOME_MESSAGE', "Hello from Terraform-provisioned Infrastructure!")
    return jsonify(
        message=message,
        status="running",
        container_platform="Docker"
    )

@app.route('/health')
def health():
    # Load balancers use this to check if the app is ready
    return jsonify(status="healthy"), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)