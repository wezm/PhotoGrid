class Flickr
  constructor: (@api_key) ->

  getPhotos: (photoset_id, callback) =>
    $.ajax
      url: 'http://api.flickr.com/services/rest/'
      data:
        api_key: @api_key
        method: 'flickr.photosets.getPhotos'
        photoset_id: photoset_id
        extras: 'url_sq,url_z,date_taken'
        format: 'json'
      dataType: 'jsonp'
      jsonp: 'jsoncallback'
      success: (data, textStatus, jqXHR) ->
        callback(data.photoset.photo)
      error: ->
        callback(null, 'some error')

window.Flickr = Flickr
