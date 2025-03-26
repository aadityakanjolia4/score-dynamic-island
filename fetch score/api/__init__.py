from flask import Flask
from .db import db
from .match_id import match_id_app
from .index import index_app


def create_app():
    app = Flask(__name__)
    app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///database.db"
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
    app.json.sort_keys = False

    db.init_app(app)

    # Register Blueprints
    app.register_blueprint(match_id_app)
    app.register_blueprint(index_app)

    return app
