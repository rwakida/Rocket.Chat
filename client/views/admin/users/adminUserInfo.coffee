Template.adminUserInfo.helpers
	name: ->
		return if @name then @name else TAPi18next.t 'project:Unnamed'
	email: ->
		return @emails?[0]?.address
	phoneNumber: ->
		return '' unless @phoneNumber
		if @phoneNumber.length > 10
			return "(#{@phoneNumber.substr(0,2)}) #{@phoneNumber.substr(2,5)}-#{@phoneNumber.substr(7)}"
		else
			return "(#{@phoneNumber.substr(0,2)}) #{@phoneNumber.substr(2,4)}-#{@phoneNumber.substr(6)}"
	lastLogin: ->
		if @lastLogin
			return moment(@lastLogin).format('LLL')
	utcOffset: ->
		if @utcOffset?
			if @utcOffset > 0
				@utcOffset = "+#{@utcOffset}"

			return "UTC #{@utcOffset}"

Template.adminUserInfo.events
	'click .deactivate': ->
		Meteor.call 'setUserActiveStatus', Template.currentData()._id, false, (error, result) ->
			if result
				toastr.success t('User_has_been_deactivated')
			if error
				toastr.error error.reason
	
	'click .activate': ->
		Meteor.call 'setUserActiveStatus', Template.currentData()._id, true, (error, result) ->
			if result
				toastr.success t('User_has_been_activated')
			if error
				toastr.error error.reason

	'click .delete': ->
		_id = Template.currentData()._id
		swal {
			title: t('Are_you_sure')
			text: t('Delete_User_Warning')
			type: 'warning'
			showCancelButton: true
			confirmButtonColor: '#DD6B55'
			confirmButtonText: t('Yes_delete_it')
			cancelButtonText: t('Cancel')
			closeOnConfirm: false
			html: false
		}, ->
			swal 
				title: t('Deleted')
				text: t('User_has_been_deleted')
				type: 'success'
				timer: 2000
				showConfirmButton: false 

			Meteor.call 'deleteUser', _id, (error, result) ->
				if error
					toastr.error error.reason
				
