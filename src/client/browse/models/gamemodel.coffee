define ["ember-data"],
	(DS)->		
		model = DS.Model.extend
			description: DS.attr 'string'
			title: DS.attr 'string'
			titleMediaUri: DS.attr 'string'
			
		return model
			