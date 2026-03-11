## Saga
# Type: orchestrator

So here I have several services, that try to perforom some transactional action. Some strp might fail, but if it fails, previous steps will rollback. Each action has a counter-action.

If you look (and optionally run) cmd/app/main.go, you can see how it works.