from flask import Flask, request, jsonify, render_template
import requests

app = Flask(__name__)

current_match_id = '91470'

@app.route('/update_match_id', methods=['POST'])
def update_match_id():
    global current_match_id
    data = request.form
    new_match_id = data.get('match_id')
    print(new_match_id,"new match id")
    target_url = "http://127.0.0.1:5000/score"  # Replace with the actual URL

        # Prepare data for the POST request
    # payload = {'match_id': current_match_id}

        # Send the POST request
    try:
        response = requests.get(target_url, params={'id': new_match_id})
        # response_data = response.json()  # Assuming the response is JSON
        if new_match_id:
            current_match_id = new_match_id
            return jsonify({'message': 'Match ID updated successfully','current_match_id': current_match_id})
        # return jsonify({
        #     'message': 'Match ID sent successfully',
        #     'match_id': new_match_id,
        #     'target_response': response_data
        # })
    except requests.exceptions.RequestException as e:
        return jsonify({'error': 'Failed to send request', 'details': str(e)}), 500

    # else:
    #     return jsonify({'error': 'No match ID provided'}), 400

@app.route('/current_match_id', methods=['GET'])
def get_current_match_id():
    global current_match_id
    return jsonify({'current_match_id': current_match_id})

@app.route('/match_id')
def update_match_id_page():
    return render_template('match_id.html')

if __name__ == '__main__':
    app.run(debug=True, port=5005)
