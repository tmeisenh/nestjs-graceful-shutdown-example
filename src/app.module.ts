import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { GracefulShutdownModule } from 'nestjs-graceful-shutdown';

@Module({
  imports: [
    GracefulShutdownModule.forRoot({
      cleanup: async (_app, signal) => {
        console.log('GOT SIGNAL: ', signal);
        // do whatever, close db connection pool, etc.
      },
      gracefulShutdownTimeout: Number(
        process.env.GRACEFUL_SHUTDOWN_TIMEOUT ?? 10000,
      ),
      keepNodeProcessAlive: true,
    }),
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
