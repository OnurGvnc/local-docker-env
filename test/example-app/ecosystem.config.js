module.exports = {
  apps: [
    {
      name: 'bun-app',
      cwd: './',
      script: 'bun',
      args: ['run', 'index.ts'],
      exec_mode: 'fork',
      instances: process.env.INSTANCES || 1,

      // Reuseport için
      env: {
        PORT: 3005,
        NODE_ENV: 'production',
        BUN_CONFIG: JSON.stringify({
          reusePort: true,
        }),
      },

      watch: false,

      // PM2 Plus features (opsiyonel)
      max_memory_restart: '500M',
      min_uptime: '10s',
      max_restarts: 10,

      // Graceful shutdown
      kill_timeout: 8000,
      wait_ready: true,
      listen_timeout: 3000,

      // Error handling
      merge_logs: true,
      // error_file: '/dev/null',
      // out_file: '/dev/null',
      error_file: '/dev/stderr',
      out_file: '/dev/stdout',

      // Clustering davranışı
      instance_var: 'INSTANCE_ID',
      exp_backoff_restart_delay: 100,
    },
  ],
}
