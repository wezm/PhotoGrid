month_names = [
  "January"
  "February"
  "March"
  "April"
  "May"
  "June"
  "July"
  "August"
  "September"
  "October"
  "November"
  "December"
]

$ ->
  body = $('body')

  flickr = new Flickr('87f48501c7de6881ee83eff94026d6fb')
  flickr.getPhotos '72157628659470185', (photos, error) ->
    # console.log photos
    # window.photos = new Photo(photoData) for photoData in photos

    # Partition the photos by month, ordered by day
    date_re = /^(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})$/

    photos_by_month = [
      [],[],[],[],
      [],[],[],[],
      [],[],[],[]
    ]

    # Render the photos
    for photo in photos
      matches = photo.datetaken.match(date_re)
      continue unless matches

      photo.datetaken = new Date(
        matches[1], parseInt(matches[2]) - 1, matches[3],
        matches[4], matches[5], matches[6])

      photos_by_month[photo.datetaken.getMonth()].push photo

    render month_photos, month for month_photos, month in photos_by_month

    $("a[rel^='prettyPhoto']").prettyPhoto()

  render = (photos, month) ->
    return if photos.length is 0
    month_name = month_names[month]
    h2 = $(document.createElement 'h2')
    h2.text month_name
    h2.appendTo body

    ul = $(document.createElement 'ul')
    ul.attr
      class: 'grid'

    for photo in photos
      li = $(document.createElement 'li')

      day_span = $(document.createElement 'span')
      day_span.attr 'class', 'day'
      day_span.text '' + photo.datetaken.getDate()
      day_span.appendTo li

      a  = $(document.createElement 'a')
      a.attr
        href: photo.url_z
        rel: "prettyPhoto[#{month_name}]"
        title: photo['title']
      a.appendTo li

      img = $(document.createElement 'img')
      img.attr
        width: photo.width_sq
        height: photo.height_sq
        src: photo.url_sq
      img.appendTo a

      li.appendTo ul

      ul.appendTo body

