import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  /* config options here */
output: process.env.VERCEL === '1' ? undefined: 'standalone',
};

export default nextConfig;
