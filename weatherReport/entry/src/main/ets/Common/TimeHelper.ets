function parseTime(timeStr: string): number {
  // 验证时间格式
  const regex = /^(\d{2}):(\d{2})$/;
  const match = timeStr.match(regex);
  if (!match) {
    throw new Error('Invalid time format. Expected "HH:MM".');
  }

  // 将小时和分钟转换为分钟表示
  const hours = parseInt(match[1], 10);
  const minutes = parseInt(match[2], 10);
  return hours * 60 + minutes;
}

export default function calculateMinutes(startTimeStr: string, endTimeStr: string): number {
  // 解析时间
  const startTime = parseTime(startTimeStr);
  const endTime = parseTime(endTimeStr);

  // 计算时间差
  const difference = endTime - startTime;

  // 如果结果为负，说明结束时间在开始时间之前，需要调整为正数（即计算跨天的时间差）
  // 假设一天有 24 * 60 = 1440 分钟
  if (difference < 0) {
    return 1440 + difference
  }

  return difference
}