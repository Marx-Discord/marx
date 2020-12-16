FROM google/dart:2.12-dev
WORKDIR /app
COPY pubspec.yaml .
RUN dart pub get
COPY . .
RUN dart pub get --offline
RUN dart compile exe /app/bin/marx.dart -o /app/bin/marx

FROM subfuzion/dart:slim
COPY --from=0 /app/bin/marx /app/bin/marx
COPY --from=0 /app/migrations /app/migrations
WORKDIR /app
ENTRYPOINT ["./bin/marx"]
