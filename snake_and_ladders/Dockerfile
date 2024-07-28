#FROM docker.io/moosavimaleki/timez-flutter-full:latest


#FROM docker.io/moosavimaleki/timez-flutter:latest AS build-env

#RUN mkdir -p /app/
#COPY . /app/
#WORKDIR /app/
##RUN flutter clean && flutter pub get
#RUN flutter build web --web-renderer canvaskit --dart-define=FLUTTER_WEB_CANVASKIT_URL=./canvaskit/ --release --no-tree-shake-icons


## Stage 2 - Create the run-time image
#FROM nginx:1.21.1-alpine
#COPY --from=build-env /app/build/web /usr/share/nginx/html


FROM docker.io/tghtg/teacher_app:latest AS build-env
# ENV PATH="$PATH:/flutter/bin:/flutter/bin/cache/dart-sdk/bin"
RUN mkdir -p /app/
COPY . /app/
WORKDIR /app/
# RUN flutter clean && flutter pub get
RUN flutter build web --web-renderer canvaskit --dart-define=FLUTTER_WEB_CANVASKIT_URL=./canvaskit/ --release --no-tree-shake-icons

# Stage 2 - Create the run-time image
FROM nginx:1.21.1-alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html

#dart fix --dry-run then after it finish use : dart fix --apply
