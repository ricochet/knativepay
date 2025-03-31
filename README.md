# Knative Applications with Local Kind

## Tool pre-reqs

- `kind`
- `kubectl`
- netdata `curl https://get.netdata.cloud/kickstart.sh > /tmp/netdata-kickstart.sh && sh /tmp/netdata-kickstart.sh`
- `wash`
- Docker (for validators scale demo)

## Setup local dev

```bash
./scripts/dev-setup.sh
```

Cleanup:

```bash
kind delete cluster
```

## Port-forwards

```bash
kubectl port-forward service/netdata 19998:19999
```

## Usage

```bash
kubectl get ksvc -n default

curl http://helloworld-nodejs.default.127.0.0.1.sslip.io

curl -v http://helloworld-go.default.127.0.0.1.sslip.io -w "\
DNS Lookup: %{time_namelookup}s\n\
Connect: %{time_connect}s\n\
TLS Handshake: %{time_appconnect}s\n\
TTFB: %{time_starttransfer}s\n\
Total: %{time_total}s\n"

kubectl top pods -n default

kubectl get service kourier -n knative-serving
```

## Projects

### Hello World

Simple hello world applications in Node.js and Go.

### Validators Scale Demo

A Proof of Concept for testing Knative's scaling capabilities by deploying 100+ unique validator services.

See [validators/README.md](validators/README.md) for details on how to use the validators POC.
