from api import score_app

app = score_app()

if __name__ == "__main__":
    app.run(debug=True)