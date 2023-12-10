# What's Portal

Portal is a container containing a set of tools to help debug live services.. It can be deployed as a pod or a deployment to give you access to databases and 
other IAM- or VPC- protected services.

## Apply portal deployment

Create portal deployment in `nebula` namespace:

```bash
kubectl apply -f https://raw.githubusercontent.com/nebulaclouds/nebulatools/master/portal/deployment.yaml
```

### Use a different namespace

```bash
curl https://raw.githubusercontent.com/nebulaclouds/nebulatools/master/portal/deployment.yaml | sed "s/namespace: nebula/namespace: union/" | kubectl apply -f -
```

### Use a different service account

```bash
curl https://raw.githubusercontent.com/nebulaclouds/nebulatools/master/portal/deployment.yaml | sed "s/serviceAccountName: default/serviceAccountName: foo/" | kubectl apply -f -
```

## Open a shell into the deployed pod

```bash
kubectl exec -it -n nebula deploy/portal -- bash
```

## Tools available inside:

- [X] postgresql-client (run `psql`)
- [X] redis-client (run `redis-cli`)
- [X] nebulakit
- [X] python3
