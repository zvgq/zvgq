express = require "express"
http	= require "http"
nconf	= require "nconf"

CatalogueRepository = require "../repositories/cataloguerepository"

class WWWRouter
	constructor: ()->
		@router = express.Router()
		try
			@catalogueRepo = new CatalogueRepository();
		catch ex
			throw ex

		@router.get "/", (req, res, next)=>
			res.redirect "/games"

		@router.get "/faq", (req, res, next)=>
			data =
				title: "ZVGQ - FAQ"
				analytics: nconf.get "GOOGLE_TRACKING_CODE"
				version: req.app.locals.version
			res.render "faq", data

		getGames = (req, res, next)=>
			filter = if req.params.filter then req.params.filter else 'new'
			@catalogueRepo.getGames filter, (err, results)->
				data =
					title: "ZVGQ - Games"
					analytics: nconf.get "GOOGLE_TRACKING_CODE"
					version: req.app.locals.version
					games: results.entries
				if(err)
					res.status(500).json(err)
				else
					res.render "games", data

				next()
		@router.get "/games", getGames
		@router.get "/games/:filter", getGames

		# /game
		getGame = (req, res, next)=>
			id = req.params.id
			@catalogueRepo.getGame id, true, (err, result)->
				data =
					title: "ZVGQ - Games"
					analytics: nconf.get "GOOGLE_TRACKING_CODE"
					version: req.app.locals.version
					game: result
				if(err)
					res.status(500).json(err)
				else
					res.render "game", data

		@router.get "/game/:id", getGame
		@router.get "/game", (req, res, next)=>
			res.redirect "/games"

module.exports = WWWRouter
