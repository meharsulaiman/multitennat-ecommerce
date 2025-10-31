import { withPayload } from '@payloadcms/next/withPayload';
import type { NextConfig } from 'next';

const nextConfig: NextConfig = {
  /* config options here */

  // Enable standalone output for Docker production builds
  output: 'standalone',

  // Experimental features for better Docker compatibility
  experimental: {
    // Optimize server-side rendering
    serverActions: {
      bodySizeLimit: '2mb',
    },
  },
};

export default withPayload(nextConfig);
