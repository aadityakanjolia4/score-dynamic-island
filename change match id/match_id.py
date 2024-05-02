from flask import Flask, request, jsonify, render_template

app = Flask(__name__)

current_match_id = '91470'

@app.route('/update_match_id', methods=['POST'])
def update_match_id():
    global current_match_id
    data = request.form
    new_match_id = data.get('match_id')
    print(new_match_id,"new match id")
    if new_match_id:
        current_match_id = new_match_id
        return jsonify({'message': 'Match ID updated successfully','current_match_id': current_match_id})
    else:
        return jsonify({'error': 'No match ID provided'}), 400

@app.route('/current_match_id', methods=['GET'])
def get_current_match_id():
    global current_match_id
    return jsonify({'current_match_id': current_match_id})

@app.route('/match_id')
def update_match_id_page():
    return render_template('match_id.html')

if __name__ == '__main__':
    app.run(debug=True, port=5005)
