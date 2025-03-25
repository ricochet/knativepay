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

## Port-forwards

```bash
kubectl port-forward service/netdata 19998:19999
```

## Usage

```bash
curl -v http://helloworld-nodejs.default.127.0.0.1.sslip.io
curl -v http://helloworld-go.default.127.0.0.1.sslip.io

kubectl top pods -n default

kubectl get ksvc -n default

kubectl get service kourier -n knative-serving
```

## Projects

### Hello World

Simple hello world applications in Node.js and Go.

### Validators Scale Demo

A Proof of Concept for testing Knative's scaling capabilities by deploying 100+ unique validator services.

See [validators/README.md](validators/README.md) for details on how to use the validators POC.

## Notes

```bash
# Create namespace
kubectl create ns kourier-system

# Configure domain
kubectl patch configmap/config-domain \
  --namespace knative-serving \
  --type merge \
  --patch '{"data":{"127.0.0.1.sslip.io":""}}'
```
