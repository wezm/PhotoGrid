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

day_names = [
  "Sunday"
  "Monday"
  "Tuesday"
  "Wednesday"
  "Thursday"
  "Friday"
  "Saturday"
]
one_day = 1000 * 60 * 60 * 24 # 24h

pad = (number) ->
  string = "" + number
  if string.length < 2
    string = "0" + string
  string

$ ->
  body = $('body')

  flickr = new Flickr('87f48501c7de6881ee83eff94026d6fb')
  flickr.getPhotos '72157628659470185', (photos, error) ->
    # console.log photos
    # window.photos = new Photo(photoData) for photoData in photos

    # Partition the photos by month, ordered by day
    date_re = /^((\d{4})-(\d{2})-(\d{2})) (\d{2}):(\d{2}):(\d{2})$/

    ordered_photos = {}

    # Render the photos
    for photo in photos
      matches = photo.datetaken.match(date_re)
      continue unless matches

      # photo.datetaken = new Date(
      #   matches[1], parseInt(matches[2]) - 1, matches[3],
      #   matches[4], matches[5], matches[6])

      date = matches[1]
      date_photos = ordered_photos[date]
      if not date_photos
        date_photos = []
        ordered_photos[date] = date_photos

      date_photos.push photo

    xrender ordered_photos
    # render month_photos, month for month_photos, month in photos_by_month

    $("a[rel^='prettyPhoto']").prettyPhoto()

  # roll the timestamp back to the first monday
  monday = (date) ->
    while date.getDay() != 1
      date = new Date(date.getTime() - one_day)
    date

  xrender = (photos) ->
    for month in [0...12]
      render_month month, photos

    return

    timestamp = (new Date(2012, 0, 1)).getTime() # 1 Jan
    end_timestamp = (new Date(2012, 11, 31)).getTime() # 31 Dec

    timestamp = monday(new Date(timestamp))

    last_month = 0
    while timestamp <= end_timestamp
      date = new Date(timestamp)

      day   = date.getDate()
      month = date.getMonth() + 1
      year  = date.getFullYear()
      key = "#{year}-#{pad month}-#{pad day}"
      day_photos = photos[key]

      if month != last_month
        add_month_table table, month_names[last_month - 1] if table

        table = new_table();
        tbody = table.find 'tbody'
      last_month = month

      if date.getDay() == 1
        # Start a new row
        tr = $(document.createElement 'tr')
        tr.appendTo tbody

      td = $(document.createElement 'td')
      if day_photos
        photo = day_photos[0]

        a  = $(document.createElement 'a')
        a.attr
          href: photo.url_l
          # rel: "prettyPhoto[#{month_name}]"
          title: photo['title']
        a.appendTo td

        img = $(document.createElement 'img')
        img.attr
          width: photo.width_q
          height: photo.height_q
          src: photo.url_q
        img.appendTo a
      else
        td.text key
      td.appendTo tr

      timestamp += one_day

    add_month_table table, month_names[month - 1]

  render_month = (month, photos) ->
    table = new_table()
    tbody = table.find('tbody')

    date = monday new Date(2012, month, 1)
    timestamp = date.getTime()

    tr = $(document.createElement 'tr')
    tr.appendTo tbody
    until date.getMonth() == month
      # Add the padding cells
      td = $(document.createElement 'td')
      td.addClass 'pad'

      span = $(document.createElement 'span')
      span.addClass 'day'
      span.text date.getDate()
      span.appendTo td

      td.appendTo tr

      timestamp += one_day
      date = new Date(timestamp)

    while date.getMonth() == month
      key = "#{date.getFullYear()}-#{pad(date.getMonth() + 1)}-#{pad date.getDate()}"
      day_photos = photos[key]

      if date.getDay() == 1
        # Start a new row
        tr = $(document.createElement 'tr')
        tr.appendTo tbody

      td = $(document.createElement 'td')
      span = $(document.createElement 'span')
      span.addClass 'day'
      span.text date.getDate()
      span.appendTo td

      if day_photos
        photo = day_photos[0]

        a  = $(document.createElement 'a')
        a.attr
          href: photo.url_l
          # rel: "prettyPhoto[#{month_name}]"
          title: photo['title']
        a.appendTo td

        img = $(document.createElement 'img')
        img.attr
          width: photo.width_q
          height: photo.height_q
          src: photo.url_q
        img.appendTo a

      td.appendTo tr

      timestamp += one_day
      date = new Date(timestamp)

    add_month_table table, month

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
        href: photo.url_l
        rel: "prettyPhoto[#{month_name}]"
        title: photo['title']
      a.appendTo li

      img = $(document.createElement 'img')
      img.attr
        width: photo.width_q
        height: photo.height_q
        src: photo.url_q
      img.appendTo a

      li.appendTo ul

      ul.appendTo body

  new_table = ->
    table = $(document.createElement 'table')
    table.addClass 'calendar'

    thead = $(document.createElement 'thead')
    tr = $(document.createElement 'tr')
    tr.appendTo thead

    days = [1..6]
    days.push 0
    for day in days
      th = $(document.createElement 'th')
      th.text day_names[day][0...3]
      th.appendTo tr
    thead.appendTo table
    $(document.createElement 'tbody').appendTo table
    table

  has_no_images = (table) ->
    table.find('img').length == 0

  add_month_table = (table, month) ->
    return if has_no_images(table)

    heading = $(document.createElement 'h2')
    heading.text month_names[month]
    heading.appendTo body
    table.appendTo body


