# import necessary libraries
from flask import Flask, render_template
from ScrapeMars import scrapeMars


# create instance of Flask app
app = Flask(__name__)

marsDictionary = scrapeMars()

# create route that renders index.html template
@app.route("/")
def echo():
    return render_template("index.html", **marsDictionary)

@app.route('/rescrape')
def rescrape():
    marsDictionary = scrapeMars()
    return render_template("index.html", **marsDictionary)

if __name__ == "__main__":
    app.run(debug=True)
